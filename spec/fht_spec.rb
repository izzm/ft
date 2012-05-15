require 'plymouth'
require Pathname.pwd.join('lib').join('ft.rb')

describe Array do

  before do
    @tolerance = 1.0e-08
  end

  describe 'Discrete Hartley Transform' do

    it 'should calculate DHT properly' do
      data = [2.0, 1.0, 1.0, 2.0]
      result = data.dht
      result[0].should be_within(@tolerance).of(3.0)
      result[1].should be_within(@tolerance).of(0.0)
      result[2].should be_within(@tolerance).of(0.0)
      result[3].should be_within(@tolerance).of(1.0)
      result = result.dht
      result[0].should be_within(@tolerance).of(2.0)
      result[1].should be_within(@tolerance).of(1.0)
      result[2].should be_within(@tolerance).of(1.0)
      result[3].should be_within(@tolerance).of(2.0)
    end

    it 'should calculate DHT properly for 2D data' do
      data = [[1.0, 1.0, 1.0, 1.0],
              [1.0, 2.0, 2.0, 1.0],
              [1.0, 2.0, 2.0, 1.0],
              [1.0, 1.0, 1.0, 1.0]]
      result = data.dht2d
      result[0][0].should be_within(@tolerance).of( 5.0)
      result[0][1].should be_within(@tolerance).of( 0.0)
      result[0][2].should be_within(@tolerance).of( 0.0)
      result[0][3].should be_within(@tolerance).of(-1.0)
      result[1][0].should be_within(@tolerance).of( 0.0)
      result[1][1].should be_within(@tolerance).of( 0.0)
      result[1][2].should be_within(@tolerance).of( 0.0)
      result[1][3].should be_within(@tolerance).of( 0.0)
      result[2][0].should be_within(@tolerance).of( 0.0)
      result[2][1].should be_within(@tolerance).of( 0.0)
      result[2][2].should be_within(@tolerance).of( 0.0)
      result[2][3].should be_within(@tolerance).of( 0.0)
      result[3][0].should be_within(@tolerance).of(-1.0)
      result[3][1].should be_within(@tolerance).of( 0.0)
      result[3][2].should be_within(@tolerance).of( 0.0)
      result[3][3].should be_within(@tolerance).of( 1.0)
      result = result.dht2d
      result[0][0].should be_within(@tolerance).of( 1.0)
      result[0][1].should be_within(@tolerance).of( 1.0)
      result[0][2].should be_within(@tolerance).of( 1.0)
      result[0][3].should be_within(@tolerance).of( 1.0)
      result[1][0].should be_within(@tolerance).of( 1.0)
      result[1][1].should be_within(@tolerance).of( 2.0)
      result[1][2].should be_within(@tolerance).of( 2.0)
      result[1][3].should be_within(@tolerance).of( 1.0)
      result[2][0].should be_within(@tolerance).of( 1.0)
      result[2][1].should be_within(@tolerance).of( 2.0)
      result[2][2].should be_within(@tolerance).of( 2.0)
      result[2][3].should be_within(@tolerance).of( 1.0)
      result[3][0].should be_within(@tolerance).of( 1.0)
      result[3][1].should be_within(@tolerance).of( 1.0)
      result[3][2].should be_within(@tolerance).of( 1.0)
      result[3][3].should be_within(@tolerance).of( 1.0)
    end


  end

  describe 'Fast Hartley Transform' do

    it 'should calculate FHT properly' do
      data = [2.0, 1.0, 1.0, 2.0]
      result = data.fht
      result[0].should be_within(@tolerance).of(3.0)
      result[1].should be_within(@tolerance).of(0.0)
      result[2].should be_within(@tolerance).of(0.0)
      result[3].should be_within(@tolerance).of(1.0)
      result = result.fht
      result[0].should be_within(@tolerance).of(2.0)
      result[1].should be_within(@tolerance).of(1.0)
      result[2].should be_within(@tolerance).of(1.0)
      result[3].should be_within(@tolerance).of(2.0)
    end

    it 'should calculate FHT properly for 2D data' do
      data = [[1.0, 1.0, 1.0, 1.0],
              [1.0, 2.0, 2.0, 1.0],
              [1.0, 2.0, 2.0, 1.0],
              [1.0, 1.0, 1.0, 1.0]]
      result = data.fht2d
      result[0][0].should be_within(@tolerance).of( 5.0)
      result[0][1].should be_within(@tolerance).of( 0.0)
      result[0][2].should be_within(@tolerance).of( 0.0)
      result[0][3].should be_within(@tolerance).of(-1.0)
      result[1][0].should be_within(@tolerance).of( 0.0)
      result[1][1].should be_within(@tolerance).of( 0.0)
      result[1][2].should be_within(@tolerance).of( 0.0)
      result[1][3].should be_within(@tolerance).of( 0.0)
      result[2][0].should be_within(@tolerance).of( 0.0)
      result[2][1].should be_within(@tolerance).of( 0.0)
      result[2][2].should be_within(@tolerance).of( 0.0)
      result[2][3].should be_within(@tolerance).of( 0.0)
      result[3][0].should be_within(@tolerance).of(-1.0)
      result[3][1].should be_within(@tolerance).of( 0.0)
      result[3][2].should be_within(@tolerance).of( 0.0)
      result[3][3].should be_within(@tolerance).of( 1.0)
      result = result.fht2d
      result[0][0].should be_within(@tolerance).of( 1.0)
      result[0][1].should be_within(@tolerance).of( 1.0)
      result[0][2].should be_within(@tolerance).of( 1.0)
      result[0][3].should be_within(@tolerance).of( 1.0)
      result[1][0].should be_within(@tolerance).of( 1.0)
      result[1][1].should be_within(@tolerance).of( 2.0)
      result[1][2].should be_within(@tolerance).of( 2.0)
      result[1][3].should be_within(@tolerance).of( 1.0)
      result[2][0].should be_within(@tolerance).of( 1.0)
      result[2][1].should be_within(@tolerance).of( 2.0)
      result[2][2].should be_within(@tolerance).of( 2.0)
      result[2][3].should be_within(@tolerance).of( 1.0)
      result[3][0].should be_within(@tolerance).of( 1.0)
      result[3][1].should be_within(@tolerance).of( 1.0)
      result[3][2].should be_within(@tolerance).of( 1.0)
      result[3][3].should be_within(@tolerance).of( 1.0)
    end

  end

end
