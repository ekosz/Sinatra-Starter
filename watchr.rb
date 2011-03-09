ENV["WATCHR"] = "1"

def run(cmd)
  system('clear')
  puts(cmd)
  system(cmd)
end

def run_test(test)
  result = run "rspec #{test}"
  growl result.split("\n").last rescue nil
end

def run_all_tests
  result = run "rspec spec/"
  growl result.split("\n").last rescue nil
end

def related_tests(path)
  Dir['test/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}_spec.rb/ }
end

def run_all_stories
  run "cucumber"
end

def run_story(story)
  run "cucumber #{story}"
end

def run_suite
  run_all_tests
  run_all_stories
end

watch('app/.*/.*\.rb') { |m| related_tests(m[1]).map {|tf| run_test tf } }
watch('spec/spec_helper\.rb') { run_all_tests }
watch('spec/helpers/.*_spec\.rb') { |m| run_test m[0] }
watch('spec/models/.*_spec\.rb') { |m| run_test m[0] }
watch('spec/routes/.*_spec\.rb') { |m| run_test m[0] }
watch('spec/views/.*_spec\.rb') { |m| run_test m[0] }

watch('features/support/.*\.rb') { |m| run_all_stories }
watch('features/.*\.feature') { |m| run_story m[0] }

watch('spec/factories\.rb') { run_suite }


# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running Suite ---\n\n"
  run_suite
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end

