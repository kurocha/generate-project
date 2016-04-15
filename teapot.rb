
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0.0"

define_generator "project" do |generator|
	generator.description = <<-EOF
		Generates a basic project for use with the dream-framework.
	EOF
	
	generator.generate do |project_name|
		source_path = Pathname("source/#{project_name}")
		test_path = Pathname("test/")
		
		name = Build::Name.new(project_name)
		substitutions = Substitutions.new
		
		# e.g. Foo Bar, typically used as a title, directory, etc.
		substitutions['PROJECT_NAME'] = name.text
		
		# e.g. FooBar, typically used as a namespace
		substitutions['PROJECT_IDENTIFIER'] = name.identifier
		
		# e.g. foo-bar, typically used for targets, executables
		substitutions['PROJECT_TARGET_NAME'] = name.target
		
		# The user's current name:
		current_date = Time.new
		substitutions['DATE'] = current_date.strftime("%-d/%-m/%Y")
		substitutions['YEAR'] = current_date.strftime("%Y")
		substitutions['AUTHOR_NAME'] = `git config --global user.name`.chomp!
		
		generator.copy('templates/project', '.', substitutions)
		
		repository = Repository.new(context.root)
		repository.add(:all)
		repository.commit("Initial project structure.")
	end
end
