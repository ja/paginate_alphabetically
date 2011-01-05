module PaginateAlphabetically
  module ViewHelpers
    def alphabetically_paginate(collection, options = {})
      if options[:always_display]
        available_letters = PaginateAlphabetically::ALL_LETTERS
      else
        return "" if collection.empty?
        available_letters = collection.first.class.pagination_letters
      end
      content_tag(:ul, safe(alphabetical_links_to(available_letters, options)),
                  :class => options[:class] || "pagination")
    end

    def safe(content)
      if content.respond_to?(:html_safe)
        return content.html_safe
      end
      content
    end

    def alphabetical_links_to(available_letters, options = {})
      ('A'..'Z').map do |letter|
        content_tag(:li, paginated_letter(available_letters, letter, options))
      end.join(" ")
    end

    def paginated_letter(available_letters, letter, options = {})
      if available_letters.include?(letter)
        url = "#{request.path}?letter=#{letter}"

        if options[:preserve_query]
          url << '&' + request.query_string.split('&').reject { |elem| elem =~ /^letter=/ }.join('&')
        end

        link_to(letter, url)
      else
        letter
      end
    end
  end
end
