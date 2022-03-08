# frozen_string_literal: true

shared_examples 'event source' do
  it 'schedules event job' do
    expect { interactor.run }.to have_enqueued_job(Events::CreateUserEventJob)
      .with(user_id, event)
      .on_queue('events')
  end
end
