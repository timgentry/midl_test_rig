require 'ndr_import'
require 'ndr_import/universal_importer_helper'

# Reads file using NdrImport ETL logic and creates hashes
class MetadataImporter
  include NdrImport::UniversalImporterHelper

  def initialize(filename, table_mappings, _output_path = '')
    @filename = filename
    @table_mappings = YAML.load_file table_mappings

    ensure_all_mappings_are_tables
  end

  def process
    data_items = []
    extract(@filename).each do |table, rows|
      table.transform(rows).each do |_klass, fields, _index|
        mapped_fields = fields.except(:rawtext)
        next if mapped_fields.empty?

        data_items << mapped_fields
      end
    end

    data_items
  end

  private

    def ensure_all_mappings_are_tables
      return if @table_mappings.all? { |table| table.is_a?(NdrImport::Table) }

      raise 'Mappings must be inherit from NdrImport::Table'
    end

    def unzip_path
      @unzip_path ||= SafePath.new('unzip_path')
    end

    def get_notifier(_value); end
end
