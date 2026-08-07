# frozen_string_literal: true

# app/helpers/icon_helper.rb

module IconHelper
  def inline_svg(path, options = {})
    return ''.html_safe if path.blank?

    file = Rails.root.join('app/assets/images', path)
    return ''.html_safe unless File.exist?(file)

    svg = File.read(file)

    if options[:class].present?
      svg = svg.sub(
        /<svg\b/,
        "<svg class=\"#{ERB::Util.html_escape(options[:class])}\""
      )
    end

    # rubocop:disable Rails/OutputSafety
    # SVG content originates from trusted local assets, and class options are HTML escaped.
    svg.html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
