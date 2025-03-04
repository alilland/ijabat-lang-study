# frozen_string_literal: true

namespace :read do
  task :gpt do
    p 'hello'
    phrase = 'What is Christianity?'
    lang = 'arabic'
    hl = 'ar'
    lr = 'lang_ar'
    res = GPT.translate(phrase, lang, hl, lr)

    p res
  end
end
