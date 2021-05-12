# frozen_string_literal: true

require_relative '../metadata_importer'

file 'resources/gdppr-data-items_v2.xlsx' do |t|
  uri = URI('https://digital.nhs.uk/binaries/content/assets/website-assets/coronavirus/' \
            'gpes-data-for-planning-and-research/gdppr-data-items_v2.xlsx')

  sh('curl', '-o', t.name,
     # '--header', 'Accept: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     uri.to_s) do |ok, res|
    raise "GDPPR Data Items not found (status = #{res.exitstatus})" unless ok
  end
end
# CLEAN << 'resources/gdppr-data-items_v2.xlsx'

file 'resources/gdppr-data-items_v2.yml' => 'resources/gdppr-data-items_v2.xlsx' do |t|
  require 'midl'
  require 'midl/metadata_importer'

  source_file = SafePath.new('resources').join(File.basename(t.source))
  mapping_file = SafePath.new('resources').join("#{File.basename(t.source, '.*')}.spec.yml")

  data_items = MetadataImporter.new(source_file, mapping_file).process

  File.open(t.name, 'w') { |file| file.write(data_items.to_yaml) }
end
