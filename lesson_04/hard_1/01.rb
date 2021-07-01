=begin
- Modify the given code such that any access to data results in a log entry
  being generated. 
- Any call to the SecretFile class that results in data being returned should
  first call the SecretLogger class
=end

class SecretFile
  attr_reader :log

  def initialize(secret_data, log)
    @log = log
    @data = secret_data
  end

  # create new getter method that logs entry in the log object
  def data
    log.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end
