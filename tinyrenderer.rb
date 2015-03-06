require 'matrix'
require 'ruby-prof'

class MutableMatrix < Matrix
  def []=(x, y, val)
    @rows[y][x] = val
  end

  def flip_vertically
    self.row_vectors.reverse.each_with_index do |row, y|
      @rows[y] = row
    end
  end
end

# consts
OUT_W 	= 100
OUT_H 	= 100

BLACK = [0,   0,   0,   1]
RED 	= [255, 0,   0,   1]
WHITE	= [255, 255, 255, 1]

# funcs
def draw(buffer, out_file)
  require 'pixels'
  out = Pixels.create_tga(out_file, {
    width: buffer.column_size,
    height: buffer.row_size,
    color_depth: 24,
    has_alpha: true,
  })
  buffer.row_vectors.each_with_index do |row, y|
    out.put_row_rgb(y, row.to_a)
  end
  out.close
end

def line(buffer, x0, y0, x1, y1, color)
  steep = false
  if (x0-x1).abs < (y0-y1).abs # mark steep
    x0, y0 = y0, x0
    x1, y1 = y1, x1
    steep = true
  end

  if x0 > x1 # draw from left to right
    x0, x1 = x1, x0
    y0, y1 = y1, y0
  end

  x = x0
  while x <= x1 do
    t = (x - x0)/(x1-x0).to_f
    y = ((y0 * (1.0 - t)) + (y1 * t)).round
    if steep
      buffer[y, x] = color
    else
      buffer[x, y] = color
    end
    x += 1
  end
end

buffer = MutableMatrix.build(OUT_H, OUT_W) { BLACK }

line(buffer, 0, 99, 99, 0, WHITE)
line(buffer, 25, 26, 77, 82, RED)

buffer.flip_vertically # i want to have the origin at the left bottom corner of the image

draw buffer, 'out.tga'
