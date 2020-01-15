class Components::List < Components::BaseComponent
  def initialize(opts)
    super

    draw_rows
  end

  def update_row(index, opts)
    row = rows[index]
    row.remove
    row.size = opts[:size]
    row.text = encoded_text(opts[:text])
    row.x = opts[:x]
    row.y = opts[:y]
    row.add
    row
  end

  private

  def draw_rows
    opts[:row_count].times do
      rows << text_object
    end
  end

  def rows
    @rows ||= []
  end

  def text_object
    Text.new('')
  end

  def encoded_text(text)
    text.dup.force_encoding('utf-8').encode('iso-8859-4')
  end
end
