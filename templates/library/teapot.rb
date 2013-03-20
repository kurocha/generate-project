
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

required_version "0.7"

define_target "$PROJECT_NAME" do |target|
	target.install do |environment|
		install_directory(package.path, 'source', environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	
	target.provides "Library/$PROJECT_NAME" do
		append linkflags "-l$PROJECT_NAME"
	end
end

define_target "$PROJECT_NAME-tests" do |target|
	target.install do |environment|
		install_directory(package.path, 'test', environment)
	end
	
	target.depends :platform
	target.depends "Language/C++11"
	target.depends "Library/UnitTest"
	target.depends "Library/$PROJECT_NAME"
	
	target.provides "Test/$PROJECT_NAME"
end

define_configuration 'dream' do |config|
	# Provides variant-debug and variant-release:
	config.package "variants"

	# Provides suitable packages for building on darwin:
	host /darwin/ do
		config.package "platform-darwin-osx"
		config.package "platform-darwin-ios"
	end

	# Provides suitable packages for building on linux:
	host /linux/ do
		config.package "platform-linux"
	end

	# Provides suitable packages for building on windows:
	host /windows/ do
		config.package "platform-windows"
	end

	# Unit testing
	config.package "unit-test"
	config.package "euclid"
	config.package "dream"
	
	config.package "project"
end
