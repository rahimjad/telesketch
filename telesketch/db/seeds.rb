story = Story.create

story.inputs << Image.create(image_path: 'Hello')
story.inputs << Text.create(caption: 'World')
story.inputs << Image.create(image_path: 'Hello')
story.inputs << Text.create(caption: 'World')
story.inputs << Image.create(image_path: 'Hello')
story.inputs << Text.create(caption: 'World')