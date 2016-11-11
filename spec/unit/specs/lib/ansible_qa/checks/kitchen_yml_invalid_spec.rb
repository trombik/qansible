require "spec_helper"

class QAnsibleQA
  class Check
    describe KitchenYml do
      context "When .kitchen.yml is invalid" do
        let(:instance) do
          QAnsibleQA::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          QAnsibleQA::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          KitchenYml.new
        end

        describe ".must_have_transport" do
          it "does not raise error" do
            expect { instance.must_have_transport }.not_to raise_error
          end
        end

        describe ".must_have_transport_name" do
          it "does not raise_error" do
            expect { instance.must_have_transport_name }.not_to raise_error
          end
        end

        describe ".must_have_transport_name_rsync" do
          it "raise_error" do
            expect { instance.must_have_transport_name_rsync }.not_to raise_error
          end
        end

        describe ".must_have_provisioner" do
          it "does not raise_error" do
            expect { instance.must_have_provisioner }.not_to raise_error
          end
        end

        describe ".should_have_idempotency_test_enabled" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_have_idempotency_test_enabled
          end
        end

        describe ".should_have_ansible_vault_password_file" do
          it "warns" do
            expect(instance).to receive(:warn).at_least(:once)
            instance.should_have_ansible_vault_password_file
          end
        end

        describe ".must_have_platforms" do
          it "does not raise_error" do
            expect { instance.must_have_platforms }.not_to raise_error
          end
        end

        describe ".should_have_platforms_without_transport" do
          it "warns" do
            expect(instance).not_to receive(:warn)
          end
        end

        describe ".must_have_platforms_with_driver" do
          it "does not raise_error" do
            expect { instance.must_have_platforms_with_driver }.not_to raise_error
          end
        end

        describe ".should_have_platforms_with_driver_box_update_false" do
          it "warns" do
            expect(instance).to receive(:warn)
            instance.should_have_platforms_with_driver_box_update_false
          end
        end

        describe "._parse_box" do
          it "parses trombik/ansible-freebsd-10.3-amd64 and returns hash" do
            parsed = {
              :user => "trombik",
              :platform => "freebsd",
              :platform_version => "10.3",
              :arch => "amd64"
            }
            expect(instance._parse_box("trombik/ansible-freebsd-10.3-amd64")).to eq(parsed)
          end

          it "parses trombik/freebsd-10.3-amd64 and returns hash" do
            parsed = {
              :user => "trombik",
              :platform => "freebsd",
              :platform_version => "10.3",
              :arch => "amd64"
            }
            expect(instance._parse_box("trombik/freebsd-10.3-amd64")).to eq(parsed)
          end
        end

        describe ".should_not_have_platforms_with_name_start_with_ansible" do
          it "does not warn" do
            expect(instance).to receive(:warn)
            instance.should_not_have_platforms_with_name_start_with_ansible
          end
        end

        describe ".must_have_array_of_suite" do
          it "does not raise_error" do
            expect { instance.must_have_array_of_suite }.not_to raise_error
          end
        end

        describe ".must_have_suites_with_correct_path_to_playbook" do
          it "raise_error" do
            expect { instance.must_have_array_of_suite }.not_to raise_error
          end
        end
      end
    end
  end
end
