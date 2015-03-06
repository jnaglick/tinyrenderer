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

BLACK 	= [0,   0,   0,   1]
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

# start
buffer = MutableMatrix.build(OUT_H, OUT_W) { BLACK }

buffer[52, 41] = RED

buffer.flip_vertically # i want to have the origin at the left bottom corner of the image

draw buffer
