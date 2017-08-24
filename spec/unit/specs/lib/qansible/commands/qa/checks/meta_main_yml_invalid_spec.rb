require "spec_helper"

module Qansible
  class Check
    class MetaMainYaml

      context "When meta/main.yml is invalid" do
        let(:instance) do
          Qansible::Check::Base.root(Pathname.new("spec/unit/fixtures/ansible-role-invalid/"))
          Qansible::Check::Base.tmp(Pathname.new("spec/unit/fixtures/ansible-role-latest/"))
          MetaMainYaml.new
        end

        describe ".must_exist" do
          it "does not raise_error" do
            expect { instance.must_exist }.not_to raise_error
          end
        end

        describe ".must_be_yaml" do
          it "does not raise_error" do
            expect { instance.must_be_yaml }.not_to raise_error
          end

          it "returns Hash" do
            expect(instance.must_be_yaml.class).to eq(Hash)
          end
        end

        describe ".load_yaml" do
          it "does not raise_error" do
            expect { instance.load_yaml }.not_to raise_error
          end
        end

        describe ".must_have_galaxy_info" do
          it "does not raise error" do
            expect { instance.must_have_galaxy_info }.not_to raise_error
          end
        end

        describe ".must_not_have_old_format" do
          it "raises SystemExit" do
            expect { instance.must_not_have_old_format }.to raise_error(SystemExit)
          end
        end

        describe ".must_have_mandatory_keys_in_galaxy_info" do
          it "raises SystemExit" do
            expect { instance.must_have_mandatory_keys_in_galaxy_info }.to raise_error(SystemExit)
          end
        end

        # describe ".must_have_mandatory_keys_in_galaxy_info" do
        #   it "warns" do
        #     expect(instance).to receive(:warn)
        #     instance.must_have_mandatory_keys_in_galaxy_info
        #   end
        # end

        describe ".should_not_have_default_description" do
          it "warns" do
            expect(instance).to receive(:warn).with(/description should describe the role, rather than the default/)
            instance.should_not_have_default_description
          end
        end

        describe ".must_not_have_categories" do
          it "raise_error" do
            expect { instance.must_not_have_categories }.to raise_error(SystemExit)
          end
        end

        describe ".must_not_have_min_ansible_version_less_than_2_0" do
          it "raise_error" do
            expect { instance.must_not_have_min_ansible_version_less_than_2_0 }.to raise_error(SystemExit)
          end
        end

        describe ".must_have_at_least_one_platform_supported" do
          it "raise_error" do
            expect { instance.must_have_at_least_one_platform_supported }.to raise_error(SystemExit)
          end
        end

        # describe ".must_have_array_of_galaxy_tags" do
        #   it "does not raise_error" do
        #     expect { instance.must_have_array_of_galaxy_tags }.not_to raise_error
        #   end
        # end

        describe ".should_have_at_least_one_tag" do
          it "warns" do
            expect(instance).to receive(:warn).once
            instance.should_have_at_least_one_tag
          end
        end

        # describe ".check" do
        #   it "warns" do
        #     expect(instance).to receive(:warn)
        #     instance.check
        #   end
        # end

        describe ".check" do
          it "exits with SystemExit" do
            expect { instance.check }.to raise_error(SystemExit)
          end
        end
      end

    end
  end
end
