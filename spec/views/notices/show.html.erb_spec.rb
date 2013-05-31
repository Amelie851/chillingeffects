require 'spec_helper'

describe 'notices/show.html.erb' do
  it "displays a metadata from a notice" do
    notice = build(:notice)
    assign(:notice, notice)

    render

    expect(rendered).to include notice.title
    expect(rendered).to include notice.date_received.to_s
  end

  it "displays the notices file" do
    notice = create(:notice_with_notice_file, content: "File content")
    assign(:notice, notice)

    render

    expect(rendered).to include("File content")
  end

  it "displays a notice with tags" do
    notice = create(:notice, :with_tags)
    assign(:notice, notice)

    render

    within('#tags') do |node|
      expect(node).to have_content("a_tag")
    end
  end

  it "displays a notice with entities" do
    notice = create(:notice_with_entities)
    assign(:notice, notice)

    render

    within('#entities') do |node|
      notice.entities.each do |entity|
        expect(node).to have_content(entity.name)
      end
    end
  end

  it "displays a notice with all relevant questions" do
    category_question = create(:relevant_question, question: "Q 1", answer: "A 1")
    notice_question = create(:relevant_question, question: "Q 2", answer: "A 2")
    assign(:notice, create(:notice,
      categories: [create(:category, relevant_questions: [category_question])],
      relevant_questions: [notice_question]
    ))

    render

    [category_question, notice_question].each do |question|
      within("#relevant_question_#{question.id}") do |node|
        expect(node).to have_content(question.question)
        expect(node).to have_content(question.answer)
      end
    end
  end

  it "displays a notice's works and infringing urls" do
    notice = create(:notice, :with_infringing_urls)
    assign(:notice, notice)

    render

    notice.works.each do |work|
      within("#work_#{work.id}") do |node|
        expect(node).to have_content(work.description)
        expect(node).to have_content(work.url)

        work.infringing_urls.each do |url|
          within("#infringing_url_#{url.id}") do |inner_node|
            expect(inner_node).to have_content(url.url)
          end
        end
      end
    end
  end
end
