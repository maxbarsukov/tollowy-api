# frozen_string_literal: true

shared_examples 'failed interactor' do
  it 'failures' do
    interactor.run
    expect(context).to be_failure
  end

  it 'has error data' do
    interactor.run
    expect(context.error_data).to eq(error_data)
  end
end
