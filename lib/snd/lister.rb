require 'json'
require 'net/http'
require 'rexml/document'
include REXML

module Lister

  # Get the list of versions from a Sonatype Nexus repo
  def from_nexus(repo, group, artifact)
    url = "#{repo}/service/local/data_index?g=#{group}&a=#{artifact}"
    resp = Net::HTTP.get_response( URI.parse(url))
    doc = REXML::Document.new( resp.body )
    versions = []
    XPath.each( doc, "//data/artifact" ) do |r|
      versions << r.elements["version"].text
    end
    versions.uniq
  end

  # Use a command to generate the list of versions
  def from_command(command)
    system(command).join(' ')
  end

end