require 'json'
require 'net/http'
require 'rexml/document'
require 'open3'
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
    run_safely(command).split(' ').uniq
  end

  def run_safely(command)
    result = ''
    exit_code = false
    begin
      Open3.popen2e(command) do |stdin, stdout, wait_thr|
        result = stdout.read
        exit_code = wait_thr.value.success?
      end
    rescue Errno::ENOENT
      exit_code = false
    end
    exit_code ? result : 'Failure'
  end
end