# This is the default configurator that PuppetMaster will call
# so you can use it to determine which environment
# configurator you want to load
main do |m, config, controller|
  config[:environment] = 'production' if config[:daemonize]
  config[:environment] = 'development' if config[:environment].nil?

  call(config[:environment])
end

development do |m, config, controller|
  call :common
end

production do |m, config, controller|
  call :common

  unless config.include?(:servers)
    m.family.main_puppet.count = 3
  end
end

common do |m, config, controller|
  fam = m.single_family!

  if config.include?(:tag)
    proc_tag = "#{config[:tag]}.etro.#{config[:environment]}"
  else
    proc_tag = "etro.#{config[:environment]}"
  end

  if config.include?(:servers)
    count = config[:servers]
  else
    count = 1
  end

  logging_debug = true
  case config[:environment]
  when 'production'
    logging_debug = false
    logging_trace = false
  else
  end

  m.proc_tag = proc_tag
  fam.thin_puppet(:proc_tag => proc_tag,
                  :adapter => :rails,
                  :adapter_options => config,
                  :logging_debug => logging_debug,
                  :logging_trace => logging_trace,
                  :count => count)
end
