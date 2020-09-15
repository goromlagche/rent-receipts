# frozen_string_literal: true

require 'ttfunk'
require 'prawn'
require 'humanize'
require 'date'

# params
rent = ENV['RENT'].to_i
address = ENV['ADDRESS']
landlord = ENV['LANDLORD']
tenant = ENV['TENANT']
is_pan = ENV['IS_PAN']
year = ENV['YEAR']
pan_number = ENV['PAN_NUMBER']

def date_formatter(date)
  date.strftime("#{date.day.ordinalize} %B %Y")
end

class Integer
  def ordinalize
    if (11..13).include?(self % 100)
      "#{self}th"
    else
      case self % 10
      when 1 then "#{self}st"
      when 2 then "#{self}nd"
      when 3 then "#{self}rd"
      else "#{self}th"
      end
    end
  end
end

Prawn::Document.generate('rent.pdf') do
  from = Date.parse("1st March, #{year}")

  font_families.update('LiberationSans' => {
                         normal: '/usr/share/fonts/ttf-liberation/LiberationSans-Regular.ttf',
                         italic: '/usr/share/fonts/ttf-liberation/LiberationSans-Italic.ttf',
                         bold: '/usr/share/fonts/ttf-liberation/LiberationSans-Bold.ttf',
                         bold_italic: '/usr/share/fonts/ttf-liberation/LiberationSans-BoldItalic.ttf'
                       })

  font_families.update('LiberationMono' => {
                         normal: '/usr/share/fonts/ttf-liberation/LiberationMono-Regular.ttf',
                         italic: '/usr/share/fonts/ttf-liberation/LiberationMono-Italic.ttf',
                         bold: '/usr/share/fonts/ttf-liberation/LiberationMono-Bold.ttf',
                         bold_italic: '/usr/share/fonts/ttf-liberation/LiberationMono-BoldItalic.ttf'
                       })

  12.times do |id|
    start_new_page if (id % 3).zero? && !id.zero?

    month = from.strftime('%B')
    year = from.year
    to = from.next_month.prev_day
    font('LiberationMono', size: 18, style: :bold) do
      formatted_text [
        { text: 'RENT RECEIPT' },
        { text: " ##{id + 1}" }
      ]
    end

    pad(3) do
      font('LiberationMono', size: 16) do
        text "#{month} #{year}"
      end
      font('LiberationMono', size: 14) do
        text "Date: #{date_formatter(from.next_month)}", align: :right
      end
    end

    pad(5) do
      font('LiberationSans', size: 12) do
        formatted_text [
          { text: 'Received from ' },
          { text: tenant, styles: [:bold] }
        ]

        formatted_text [
          { text: 'The sum of ' },
          { text: " Rs.#{rent}/- (Rupees #{rent.humanize.capitalize} only)",
            styles: [:bold] }
        ], character_spacing: 0.5

        formatted_text [
          { text: 'For rent at ' },
          { text: address, styles: [:bold] }
        ], character_spacing: 0.5

        formatted_text [
          { text: 'For the period from ' },
          { text: date_formatter(from), styles: [:bold] },
          { text: ' to ' },
          { text: date_formatter(to), styles: [:bold] }
        ], character_spacing: 0.5
      end
    end

    if is_pan
      move_down 5
      font('LiberationMono', size: 14) do
        text "PAN : #{pan_number}"
      end
    end

    move_down 25
    font('LiberationMono') do
      horizontal_line 280, 540
      stroke
      move_down 10
      formatted_text [
        { text: landlord, size: 12, styles: [:bold] },
        { text: ' (Landlord)', size: 12, color: 'A9A9A9', styles: [:bold] }
      ], align: :right
    end

    move_down 20
    from = to.next_day

    unless ((id + 1) % 3).zero?
      stroke_horizontal_rule
      move_down 20
    end
  end
end
