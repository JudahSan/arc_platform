# frozen_string_literal: true

# Ensure Motor Admin resources/configs from config/motor.yml are loaded in all environments.
# In production, Motor stores resources in DB tables and does not automatically
# pick up changes to config/motor.yml unless an import/sync is triggered.
# This initializer imports the YAML on boot in a safe, idempotent way.

Rails.application.config.to_prepare do
  next unless defined?(Motor)

  yaml_path = Rails.root.join('config', 'motor.yml')
  next unless File.exist?(yaml_path)

  begin
    # Motor >= 0.4 supports loading from raw YAML string
    if defined?(Motor::Configs) && Motor::Configs.respond_to?(:load_from_yaml)
      Motor::Configs.load_from_yaml(File.read(yaml_path))
    # Fallback to older APIs if present
    elsif defined?(Motor::Configs) && Motor::Configs.respond_to?(:load_from_yaml_file)
      Motor::Configs.load_from_yaml_file(yaml_path.to_s)
    end
  rescue StandardError => e
    Rails.logger.error("[Motor] Failed to import config/motor.yml: #{e.class}: #{e.message}")
  end
end
