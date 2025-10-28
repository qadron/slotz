require 'base64'
require 'slotz'

$options    = Marshal.load( Base64.strict_decode64( ARGV.pop ) )
$executable = ARGV.pop
$execute    = !!$options[:execute]

load $executable
