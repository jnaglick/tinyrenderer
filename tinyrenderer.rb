require 'matrix'

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
def draw(buffer)
  require 'pixels'
  out = Pixels.create_tga("out.tga", {
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

def line(buffer, p0, p1, color)
  t = 0.0
  while t < 1.0 do
    x = (p0[:x]*((1.0 - t)) + p1[:x]*t).to_int
    y = (p0[:y]*((1.0 - t)) + p1[:y]*t).to_int
    buffer[x, y] = color
    t = (t + 0.01).round(2)
  end
end

# start
buffer = MutableMatrix.build(OUT_H, OUT_W) { BLACK }

line(buffer, {x: 13, y: 20}, {x: 80, y: 40}, WHITE)
line(buffer, {x: 20, y: 13}, {x: 40, y: 80}, RED)

buffer.flip_vertically # i want to have the origin at the left bottom corner of the image

draw buffer
