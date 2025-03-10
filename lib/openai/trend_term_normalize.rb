# frozen_string_literal: true

class OpenAI
  ##
  def self.trend_term_normalize(language, source_term)
    headers = {
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
      'Content-Type' => 'application/json'
    }

    body = {
      model: 'gpt-4-turbo',
      messages: [
        {
          role: 'system',
          content: '
            You are a professional translator.
            Preserve the meaning, grammar, and natural phrasing in the target language.
            You will be given a potential source language and a phrase.
            The source is a google language trend search term, so its not guaranteed that it is in the language provided.
            Only respond with the translated/normalized sentence.
            If its already in english, leave it alone and return the provided word as the response.
          '.squish
        },
        {
          role: 'user',
          content: "Translate the following sentence into english from #{language}: '#{source_term}'. Ensure the translation is grammatically correct and natural."
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
