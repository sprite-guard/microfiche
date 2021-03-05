def tick args
  if(args.state.tick_count == 0)
    args.state.x = 0
    args.state.y = 0
    args.state.z = 0
    args.state.speed = 1
    args.state.w = 16
    args.state.h = 16
    args.state.update = false
    args.state.cdepth = 4
    args.render_target(:patch).solids << [0,0,args.state.w,args.state.h]
  end
  
  if(args.inputs.keyboard.left)
    args.state.x -= args.state.speed
    args.state.update = true
  end
  if(args.inputs.keyboard.right)
    args.state.x += args.state.speed
    args.state.update = true
  end
  if(args.inputs.keyboard.up)
    args.state.y += args.state.speed
    args.state.update = true
  end
  if(args.inputs.keyboard.down)
    args.state.y -= args.state.speed
    args.state.update = true
  end
  if(args.inputs.mouse.wheel)
    args.state.z -= args.inputs.mouse.wheel.y
    args.state.update = true
  end
  state_str = [args.state.x, args.state.y, args.state.z].to_s
  args.outputs.labels << { x: 40, y: 60, text: state_str }
  if(args.state.update)
    draw_block(
      {x: args.state.x, y: args.state.y, z: args.state.z},
      args
    )
    args.state.update = false
  end
  args.outputs.sprites << {
    x: 100,
    y: 100,
    w: 128,
    h: 128,
    source_x: 0,
    source_y: 0,
    source_w: 16,
    source_h: 16,
    path: :patch
  }
end

def num2bits n, args
  res = []
  while ((n > 0) and (res.length < (args.state.w * args.state.h)))
    res << (n % args.state.cdepth)
    n = (n / args.state.cdepth).floor
  end
  while res.length < (args.state.w * args.state.h)
    res.unshift(0.to_i)
  end
  return res
end

def draw_block locator, args
  red = num2bits(locator[:x],args)
  green = num2bits(locator[:y],args)
  blue = num2bits(locator[:z],args)
  $test_blue = blue
  w = args.state.w
  h = args.state.h
  w.times do |x|
    h.times do |y|
      index = (y * w) + x
      r = red[index] * (255 / args.state.cdepth).floor
      g = green[index] * (255 / args.state.cdepth).floor
      b = blue[index] * (255 / args.state.cdepth).floor
      args.render_target(:patch).solids << {
        x: x,
        y: y,
        w: 1,
        h: 1,
        r: r,
        g: g,
        b: b,
        a: 255
      }
    end
  end
end