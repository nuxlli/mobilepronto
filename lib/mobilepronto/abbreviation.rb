# encoding: UTF-8

class MobilePronto
  class Abbreviation
    class << self
      def abbr(name, limit = nil)
        limit ||= name.size
        words   = name.to_s.split(' ')
        name    = [words.shift]

        while(words.size > 0 && (name + words).join(' ').size > limit) do
          name << "#{words.shift[0.1]}."
        end

        name.concat(words).join(' ')
      end
    end
  end
end
