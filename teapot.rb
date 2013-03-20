
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.7"

define_generator "project" do |generator|
	generator.description = <<-EOF
		Generates a basic project for use with the dream-framework.
		
		See http://dream-framework.org/help/generators/project for more information.
	EOF
	
	generator.generate do |project_name|
		# generator.append('templates/project/teapot.rb', 'teapot.rb')
	end
end

define_generator "class" do |generator|
	generator.description = <<-EOF
		Generates a basic class file in the project.
		
		See http://dream-framework.org/help/generators/class for more information.
	EOF
	
	generator.generate do |class_name|
		*path, name = class_name.split(/::/)
		
		directory = Pathname path.join('/')
		directory.mkpath
		
		File.open(directory + name, "w") do |file|
			file.puts class_name
		end
	end
end
