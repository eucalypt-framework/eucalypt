require 'spec_helper'
require_relative 'generate_article_content'

include BlogHelpers

describe Eucalypt do
  describe BlogArticle do
    context 'Generate' do
      before(:all) do
        name = 'test-article'
        date = Time.now.strftime "%Y/%m/%d"
        @article = {
          name: name,
          date: date,
          file: File.join('app', 'views', 'blog', 'markdown', date, "#{name}.md"),
          directory: File.join('app', 'assets', 'blog', date, name)
        }
        Temporary.create_app '-b'
        tmp { execute "blog article generate #{@article[:name]}" }
      end
      after(:all) { Temporary.clear }

      it "should generate an article markdown file" do
        expect(tmp { File.file? @article[:file] }).to be true
      end

      it "should generate an article asset directory" do
        expect(tmp { File.directory? @article[:directory] }).to be true
      end

      context "Front Matter" do
        subject { tmp { FrontMatterParser::Parser.parse_file(@article[:file]).front_matter.symbolize_keys } }

        it "should have the correct title field" do
          expect(subject[:title]).to eq("TODO")
        end

        it "should have the correct tags field" do
          expect(subject[:tags]).to eq(["TODO"])
        end

        it "should have the correct urltitle field" do
          expect(subject[:urltitle]).to eq("test-article")
        end

        it "should have the correct time field" do
          expect(subject[:time]).to include(@article[:date].gsub ?/, ?-)
        end

        it "should have the correct assetpath field" do
          expect(subject[:assetpath]).to eq("/assets/#{@article[:date]}/#{@article[:name]}/")
        end
      end
    end
    describe 'List' do
      before(:all) do
        Temporary.create_app '-b'
        @names = %w[test-1 test-2 test-3]
        @date = Time.now.strftime "%Y/%m/%d"
        tmp do
          @names.each {|name| execute "blog article generate #{name}"; sleep 1 }
        end
      end
      after(:all) { Temporary.clear }

      context 'No flags' do
        it 'should display article titles' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "title: TODO"
          end
        end

        it 'should display article descriptions' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "desc: TODO"
          end
        end

        it 'should display article tags' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "tags: [\"TODO\"]"
          end
        end

        it 'should display article urltitles' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "urltitle: #{name}"
          end
        end

        it 'should display article times' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "time: #{@date.gsub ?/, ?-}"
          end
        end

        it 'should display article assetpaths' do
          @names.each do |name|
            expect(tmp { execute 'blog article list' }).to include "assetpath: /assets/#@date/#{name}"
          end
        end
      end
      describe 'Flags' do
        before(:all) do
          files = [
            {title: 'Test Flags 1', desc: 'TF1', tags: %w[test flags 1],
             urltitle: 'test-flags-1', time: '2015-09-01 12:00:00',
             assetpath: '/assets/blog/2015/09/01/test-flags-1/'},
            {title: 'Test Flags 2', desc: 'TF2', tags: %w[test flags 2],
             urltitle: 'test-flags-2', time: '2015-10-01 12:00:00',
             assetpath: '/assets/blog/2015/10/01/test-flags-2/'},
            {title: 'Test Flags 3', desc: 'TF3', tags: %w[test flags 3],
             urltitle: 'test-flags-3', time: '2016-07-01 12:00:00',
             assetpath: '/assets/blog/2016/07/01/test-flags-3/'},
            {title: 'Test Flags 4', desc: 'TF4', tags: %w[test flags 4],
             urltitle: 'test-flags-4', time: '2015-09-02 12:00:00',
             assetpath: '/assets/blog/2015/09/02/test-flags-4/'},
            {title: 'Test Flags 5', desc: 'TF5', tags: %w[test flags 5],
             urltitle: 'test-flags-5', time: '2015-07-03 12:00:00',
             assetpath: '/assets/blog/2015/07/03/test-flags-5/'},
            {title: 'Test Flags 6', desc: 'TF6', tags: %w[test flags 6],
             urltitle: 'test-flags-6', time: '2015-07-03 12:00:01',
             assetpath: '/assets/blog/2015/07/03/test-flags-6/'}
          ]
          markdown_base = File.join 'app', 'views', 'blog', 'markdown'
          files.each do |file|
            date = file[:time].split.first.gsub ?-, ?/
            tmp { FileUtils.mkdir_p File.join(markdown_base, date) }
            file_path = File.join(markdown_base, date, "#{file[:urltitle]}.md")
            tmp { File.open(file_path, ?w) {|f| f.write generate_article_content(file) } }
          end
        end

        context "--tag" do
          it "test" do
            expect(tmp { execute 'blog article list -t test' }).to include '6 article(s) found.'
          end

          it "TODO" do
            expect(tmp { execute 'blog article list -t TODO' }).to include '3 article(s) found.'
          end

          (1..6).each do |i|
            it i.to_s do
              output = tmp { execute "blog article list -t #{i}" }
              expect(output).to include '1 article(s) found.'
              urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
              expect(urltitles.length).to eq 1
              expect(urltitles).to include "test-flags-#{i}"
            end
          end
        end
        context "--ascending" do
          it do
            output = tmp { execute 'blog article list -a' }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to eq %w[test-flags-5 test-flags-6 test-flags-1 test-flags-4 test-flags-2 test-flags-3 test-1 test-2 test-3]
          end
        end
        context "--descending" do
          it do
            output = tmp { execute 'blog article list -d' }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to eq %w[test-flags-5 test-flags-6 test-flags-1 test-flags-4 test-flags-2 test-flags-3 test-1 test-2 test-3].reverse
          end
        end
        context "--year" do
          it Time.now.year.to_s do
            output = tmp { execute "blog article list -Y #{Time.now.year}" }
            expect(output).to include '3 article(s) found.'
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to eq %w[test-3 test-2 test-1]
          end

          it '2015' do
            output = tmp { execute "blog article list -Y 2015" }
            expect(output).to include '5 article(s) found.'
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to eq %w[test-flags-2 test-flags-4 test-flags-1 test-flags-6 test-flags-5]
          end

          it '2016' do
            output = tmp { execute "blog article list -Y 2016" }
            expect(output).to include '1 article(s) found.'
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to eq %w[test-flags-3]
          end
        end
        context "--month" do
          it '07' do
            output = tmp { execute "blog article list -M 07" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-3 test-flags-6 test-flags-5]
          end

          it '09' do
            output = tmp { execute "blog article list -M 09" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-4 test-flags-1]
          end

          it '10' do
            output = tmp { execute "blog article list -M 10" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-2'
          end

          it Time.now.strftime("%m") do
            output = tmp { execute "blog article list -M #{Time.now.strftime "%m"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
        context "--day" do
          it '01' do
            output = tmp { execute "blog article list -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-3 test-flags-2 test-flags-1]
          end

          it '02' do
            output = tmp { execute "blog article list -D 02" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-4'
          end

          it '03' do
            output = tmp { execute "blog article list -D 03" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-6 test-flags-5]
          end

          it Time.now.strftime("%d") do
            output = tmp { execute "blog article list -D #{Time.now.strftime "%d"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
        context "--year --month" do
          it "2015 07" do
            output = tmp { execute "blog article list -Y 2015 -M 07" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-6 test-flags-5]
          end

          it "2015 09" do
            output = tmp { execute "blog article list -Y 2015 -M 09" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-4 test-flags-1]
          end

          it "2015 10" do
            output = tmp { execute "blog article list -Y 2015 -M 10" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-2'
          end

          it "2016 07" do
            output = tmp { execute "blog article list -Y 2016 -M 07" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-3'
          end

          it Time.now.strftime("%Y %m") do
            output = tmp { execute "blog article list -Y #{Time.now.strftime "%Y"} -M #{Time.now.strftime "%m"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
        context "--year --day" do
          it "2015 01" do
            output = tmp { execute "blog article list -Y 2015 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-2 test-flags-1]
          end

          it "2015 02" do
            output = tmp { execute "blog article list -Y 2015 -D 02" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-4'
          end

          it "2015 03" do
            output = tmp { execute "blog article list -Y 2015 -D 03" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-6 test-flags-5]
          end

          it "2016 01" do
            output = tmp { execute "blog article list -Y 2016 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-3'
          end

          it Time.now.strftime("%Y %d") do
            output = tmp { execute "blog article list -Y #{Time.now.strftime "%Y"} -D #{Time.now.strftime "%d"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
        context "--month --day" do
          it "07 01" do
            output = tmp { execute "blog article list -M 07 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-3'
          end

          it "10 01" do
            output = tmp { execute "blog article list -M 10 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-2'
          end

          it "09 02" do
            output = tmp { execute "blog article list -M 09 -D 02" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-4'
          end

          it "09 01" do
            output = tmp { execute "blog article list -M 09 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-1'
          end

          it "07 03" do
            output = tmp { execute "blog article list -M 07 -D 03" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-6 test-flags-5]
          end

          it Time.now.strftime("%m %d") do
            output = tmp { execute "blog article list -M #{Time.now.strftime "%m"} -D #{Time.now.strftime "%d"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
        context "--year --month --day" do
          it "2015 07 03" do
            output = tmp { execute "blog article list -Y 2015 -M 07 -D 03" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-flags-6 test-flags-5]
          end

          it "2015 09 01" do
            output = tmp { execute "blog article list -Y 2015 -M 09 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-1'
          end

          it "2015 09 02" do
            output = tmp { execute "blog article list -Y 2015 -M 09 -D 02" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-4'
          end

          it "2015 10 01" do
            output = tmp { execute "blog article list -Y 2015 -M 10 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-2'
          end

          it "2016 07 01" do
            output = tmp { execute "blog article list -Y 2016 -M 07 -D 01" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include 'test-flags-3'
          end

          it Time.now.strftime("%Y %m %d") do
            output = tmp { execute "blog article list -Y #{Time.now.strftime("%Y")} -M #{Time.now.strftime "%m"} -D #{Time.now.strftime "%d"}" }
            urltitles = output.scan(/urltitle\: (.*) /).flatten.map{|s| s.gsub /\s+$/, '' }
            expect(urltitles).to include *%w[test-1 test-2 test-3]
          end
        end
      end
    end
  end
end