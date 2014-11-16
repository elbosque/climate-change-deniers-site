namespace :update do
  task :climate_change_positions do
    `rm #{settings.data_directory}/climate-change-positions`
    `git clone git@github.com:elbosque/climate-change-positions.git #{settings.data_directory}/climate-change-positions`
  end
end
