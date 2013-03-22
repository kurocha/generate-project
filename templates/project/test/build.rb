
compile_executable("$PROJECT_TARGET_NAME-test-runner") do
	def source_files(environment)
		FileList[root, "**/*.cpp"]
	end
end
