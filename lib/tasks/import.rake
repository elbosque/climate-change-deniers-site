namespace :import do
  task :climate_change_positions do
    Dir.foreach("#{settings.data_directory}/climate-change-positions/politicians") do |yaml|
      unless ['.','..'].include?(yaml)
        y = YAML.load(File.open("#{settings.data_directory}/climate-change-positions/politicians/#{yaml}", 'r').read)
        settings.mongo_db['climate_change_positions'].insert y
      end
    end
  end
end

