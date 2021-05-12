desc 'Spark'
task :spark do
  require 'erb'

  hash = {
    views: [
      { name: 'optouts', source: 'resources/optouts.json' },
      { name: 'patients', source: 'resources/COVID19_CRO.patient.mapped.parquet' },
      { name: 'journals', source: 'resources/COVID19_CRO.journal.mapped.parquet' }
    ],
    queries: [
      'SELECT * FROM optouts',
      'SELECT * FROM patients',
      'SELECT * FROM patients LEFT OUTER JOIN optouts ON patients.nhsnumber = optouts.nhsnumber ' \
        'WHERE optouts.nhsnumber IS NULL'
      # 'SELECT * FROM journals'
    ]
  }

  cmd = "spark-submit spark_submitter.py \"#{ERB::Util.url_encode(hash.to_json)}\""

  Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
    # pid = wait_thr.pid # pid of the started process.
    puts stdout.read

    exit_status = wait_thr.value
    next if exit_status.exited?

    raise stderr.read
  end
end
