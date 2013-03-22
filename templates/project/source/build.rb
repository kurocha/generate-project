
add_application "$PROJECT_NAME" do
	compile_executable '$PROJECT_NAME' do
		def source_files(environment)
			FileList[root, '$PROJECT_IDENTIFIER/**/*.{cpp,m,mm}']
		end
	end
	
	copy_files do
		def source_files(environment)
			FileList[root + "$PROJECT_IDENTIFIER/resources", '**/*']
		end
	end
end
