require 'huefx'

## Step 1: Auto generate automation files

# huefx = Huefx::Client.new
# puts huefx.generate_automation

## Step 2: Run the Hufx worker

huefx = Huefx::Worker.new
huefx.preform
