

module Carma.Model.CarModel where

import Data.Text
import Data.Typeable
import Data.Model
import Data.Model.View

import Carma.Model.CarMake (CarMake)


data CarModel = CarModel
  {ident :: F (Ident CarModel) "id"      "id"
  ,value :: F Text             "value"   "value"
  ,label :: F Text             "label"   "Модель"
  ,parent:: F (Ident CarMake)  "parent"  "Марка машины"
  }
  deriving Typeable


instance Model CarModel where
  type TableName CarModel = "CarModel"
  modelFields = getModelFields CarModel

view = defaultView :: View CarModel
