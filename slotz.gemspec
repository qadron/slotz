# coding: utf-8

Gem::Specification.new do |s|
    require_relative File.expand_path( File.dirname( __FILE__ ) ) + '/lib/slotz/version'

    s.name              = 'slotz'
    s.version           = Slotz::VERSION
    s.date              = Time.now.strftime( '%Y-%m-%d' )
    s.summary           = 'An application-centric, decentralised and distributed computing solution. '

    s.homepage          = 'https://github.com/qadron/cuboid'
    s.email             = 'tasos.laskos@gmail.com'
    s.authors           = [ 'Tasos Laskos' ]
    s.licenses          = ['MIT']

    s.files            += Dir.glob( 'config/**/**' )
    s.files            += Dir.glob( 'lib/**/**' )
    s.files            += Dir.glob( 'logs/**/**' )
    s.files            += Dir.glob( 'components/**/**' )
    s.files            += Dir.glob( 'spec/**/**' )
    s.files            += %w(Gemfile Rakefile slotz.gemspec)
    s.test_files        = Dir.glob( 'spec/**/**' )

    s.extra_rdoc_files  = %w(README.md LICENSE.md CHANGELOG.md)

    s.rdoc_options      = [ '--charset=UTF-8' ]

    s.add_dependency 'awesome_print',       '1.9.2'

    # Don't specify version, messes with the packages since they always grab the
    # latest one.
    s.add_dependency 'bundler'

    s.add_dependency 'concurrent-ruby'
    s.add_dependency 'vmstat',              '~> 2.3.1'
    s.add_dependency 'sys-proctable',       '~> 1.3.0'

    s.description = <<DESCRIPTION
DESCRIPTION

end
