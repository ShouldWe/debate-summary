desc 'Write Copyright notice at top of each file'
task :copyright do
  require 'rubygems'
  require 'copyright_header'

  args = {
    # dry_run: true,
    license: 'GPL3',
    copyright_software: 'Debate Summary',
    copyright_software_description: 'Croudsource arguments and debates',
    copyright_holders: [
      'Policy Wiki Educational Foundation LTD <hello@shouldwe.org>'
    ],
    copyright_years: ['2015'],
    add_path: %w(app config db lib public script test).join(':'),
    output_dir: '.'
  }

  command_line = CopyrightHeader::CommandLine.new(args)
  command_line.execute
end
