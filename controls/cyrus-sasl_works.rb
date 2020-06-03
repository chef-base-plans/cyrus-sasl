title 'Tests to confirm cyrus-sasl works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'cyrus-sasl')

control 'core-plans-cyrus-sasl-works' do
  impact 1.0
  title 'Ensure cyrus-sasl works as expected'
  desc '
  '
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  
  plan_pkg_ident = ((plan_installation_directory.stdout.strip).match /(?<=pkgs\/)(.*)/)[1]
  plan_pkg_version = (plan_pkg_ident.match /^#{plan_origin}\/#{plan_name}\/(?<version>.*)\//)[:version]
  describe command("DEBUG=true; hab pkg exec #{plan_pkg_ident} saslauthd --version") do
    its('exit_status') { should eq 0 }
    its('stderr') { should_not be_empty }
    its('stderr') { should match /saslauthd #{plan_pkg_version}/ }
    its('stdout') { should be_empty }
  end
end
