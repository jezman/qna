shared_examples_for 'API files' do
  context 'files' do
    let(:file) { item.files.first.blob }
    let(:files_response) { object_response['files'] }
    let(:file_response) { files_response.first }

    it 'rerurn list of files' do
      expect(files_response.size).to eq item.files.size
    end

    it 'returns all public fields' do
      %w[id filename].each do |attr|
        expect(file_response[attr]).to eq file.send(attr).as_json
      end
    end

    it 'contains link to file'
  end
end
