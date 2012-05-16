require 'plymouth'
require Pathname.pwd.join('lib').join('ft.rb')

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe 'data processing tools' do

    it 'should switch quartes properly' do
      data = [[2.0, 1.0, 1.0, 2.0],
              [1.0, 1.0, 1.0, 1.0],
              [1.0, 1.0, 1.0, 1.0],
              [2.0, 1.0, 1.0, 2.0]]
      data.switch_quarters.should eq([[1.0, 1.0, 1.0, 1.0],
                                      [1.0, 2.0, 2.0, 1.0],
                                      [1.0, 2.0, 2.0, 1.0],
                                      [1.0, 1.0, 1.0, 1.0]])
    end

  end

end
