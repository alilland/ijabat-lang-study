# frozen_string_literal: true

class OpenAI
  ##
  def self.translate(phrase, target_lang)
    headers = {
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
      'Content-Type' => 'application/json'
    }

    body = {
      model: 'gpt-4-turbo',
      messages: [
        {
          role: 'system',
          content: 'You are a professional translator. Preserve the meaning, grammar, and natural phrasing in the target language. Only respond with the translated sentence.'
        },
        {
          role: 'user',
          content: "Translate the following sentence into #{target_lang}: '#{phrase}'. Ensure the translation is grammatically correct and natural."
        }
      ]
    }

    response = HTTParty.post('https://api.openai.com/v1/chat/completions', headers: headers, body: body.to_json)
    if response.success?
      JSON.parse(response.body).dig('choices', 0, 'message', 'content')&.strip || 'Translation error'
    else
      "Error: #{response.body}"
    end
  end
end
