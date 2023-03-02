# Post Process Blur Example

Example of how to add a blur to everything.

Only the `post_process.*` files are relevant for our example

## Step by step - Render script

Copy the builtin `.renderscript` and `.render`.

To the render scripts init function add `self.effects_pred = render.predicate({"post_effects"})` and 

```lua
    local target_params = {
        [render.BUFFER_COLOR_BIT] = {
            format = render.FORMAT_RGBA,
            width = render.get_window_width(),
            height = render.get_window_height()
        }
    }
    self.target = render.render_target("effects", target_params)
```

The `predicate` dictates what is being rendered, we will later use this name to setup the material. The `render_target` is what we will render too instead of the frame buffer.

Now rename the `function update(self)` to `local function do_world(self, window_width, window_height)`. Create a new function called `local function do_gui(self, window_width, window_height)` remove this bit from your `do_world` function and put it into your `do_gui`

```lua
    local view_gui = vmath.matrix4()
    local proj_gui = vmath.matrix4_orthographic(0, window_width, 0, window_height, -1, 1)
    local frustum_gui = proj_gui * view_gui

    render.set_view(view_gui)
    render.set_projection(proj_gui)

    render.enable_state(render.STATE_STENCIL_TEST)
    render.draw(self.gui_pred, {frustum = frustum_gui})
    render.draw(self.text_pred, {frustum = frustum_gui})
    render.disable_state(render.STATE_STENCIL_TEST)

```

Now create a new update function `function update(self)` in there add 

```lua
function update(self)
    local window_width = render.get_window_width()
    local window_height = render.get_window_height()
    if window_width == 0 or window_height == 0 then
        return
    end
    render.set_render_target(self.target)
    do_world(self, window_width, window_height)
    render.disable_render_target(self.target)
    
    render.enable_texture(0, self.target, render.BUFFER_COLOR_BIT)
    render.draw(self.effects_pred, {frustum = frustum}) 
    render.disable_texture(0, self.target)
    
    do_gui(self, window_width, window_height)
end
```


## Step by step - Model
Create a new material and use the builtin `model.fp` and `model.vp` for it. Under Samplers add `effects` and under Tags add `post_effects`


In your main scene create a quad that is as big as your render view, center it and apply our material to it.