# frozen_string_literal: true
require 'httparty'
require 'json'

##
class GPT
  ##
  def self.translate(phrase, target_lang, hl, lr)
    headers = {
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
      'Content-Type' => 'application/json'
    }

    body = {
      model: 'gpt-4-turbo',
      messages: [
        { role: 'system', content: 'You are a translator. Only respond with the translated word.' },
        { role: 'user', content: "Translate '#{phrase}' to #{target_lang} with hl: #{hl}, lr: #{lr}." }
      ],
      max_tokens: 10
    }

    response = HTTParty.post('https://api.openai.com/v1/chat/completions', headers: headers, body: body.to_json)
    JSON.parse(response.body).dig('choices', 0, 'message', 'content').strip
  end
end
