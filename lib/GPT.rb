# frozen_string_literal: true
require 'httparty'
require 'json'


SYSTEM_PROMPT = <<~TEXT
  You are an intelligent assistant that analyzes search term competition based on Google Search results. You will evaluate an array of up to ten domains returned from a search query and assign a competitiveness score.

  ## **📌 Scoring Criteria**
  For each search term, analyze the list of domains and assign a **competitiveness score** between **-5 and 10** based on the following factors:

  ### **1️⃣ Domain Diversity (More Unique Domains = Easier to Rank)**
  - **8+ unique domains** → **+3 (Low competition)**
  - **4-7 unique domains** → **+2 (Moderate competition)**
  - **<4 unique domains** → **+1 (High competition)**

  ### **2️⃣ Presence of High-Authority Sites (Hard to Compete)**
  - If **3+ results** are from sites with **DA 80+** (e.g., Wikipedia, Forbes, NYTimes, Britannica, BBC, CNN, government sites), score **-3** (Very hard to rank).
  - If **1-2 high-authority sites** appear, score **-2** (Challenging, but possible).
  - If **no high-authority sites** appear, score **+3** (Easier to rank).

  ### **3️⃣ Presence of Weak or Low-Authority Sites (Easier to Rank)**
  - If **3+ weak sites** (e.g., Reddit, Quora, niche forums, Medium blogs) → **+3 (Easier to outrank)**
  - If **1-2 weak sites** → **+2 (Some competition, but beatable)**
  - If **no weak sites** → **0 (No easy ranking opportunities)**

  ### **4️⃣ Total Search Results (Fewer = Less Competition)**
  - **< 50,000 results** → **+3 (Very low competition)**
  - **50K - 500K results** → **+2 (Moderate competition)**
  - **500K - 5M results** → **+1 (Highly competitive)**
  - **5M+ results** → **0 (Extremely competitive)**

  ## **🔍 Final Decision & Ranking**
  - **Score 8-10** → **easy to rank** (Create content)
  - **Score 5-7** → **moderate** (Proceed with caution)
  - **Score 2-4** → **hard** (Consider alternative keywords)
  - **Score -5 to 1** → **very-hard** (High competition)

  ## **🔧 Strict JSON Output Requirement**
  **Your response must be valid JSON. Do not include any extra text, explanations, or markdown formatting.**

  ## **📝 JSON Response Format**
  Your response must follow this JSON structure:
  ```json
  {
    "search_term": "<your search term>",
    "score": <computed score>,
    "difficulty": "<easy | moderate | hard | very-hard>"
  }
TEXT

class GPT
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

  def self.analyze_search_term(search_term, domains, total_results)
    headers = {
      'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}",
      'Content-Type' => 'application/json'
    }
    response = HTTParty.post(
      "https://api.openai.com/v1/chat/completions",
      headers: headers,
      body: {
        model: "gpt-4-turbo",
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: "Search term: #{search_term}\nDomains: #{domains.to_json}\nTotal Results: #{total_results}" }
        ]
      }.to_json
    )

    if response.success?
      response_body = JSON.parse(response.body)
      raw_json = response_body.dig('choices', 0, 'message', 'content')&.strip || 'Translation error'

      # Parse the returned JSON string into a Ruby hash
      JSON.parse(raw_json) rescue { error: "Invalid JSON format received" }
    else
      "Error: #{response.body}"
    end
  end
end
