{-# LANGUAGE ScopedTypeVariables #-}

module Data.Model
  ( Ident(..)
  , Model(..)
  , Field
  , fieldName
  , tableName
  , ident
  ) where


import Data.Typeable
import GHC.TypeLits


data Ident model = Ident {identVal :: Int}
  deriving Eq

instance Model m => Show (Ident m) where
  show (Ident x :: Ident m) = "Ident " ++ modelName ++ " " ++ show x
    where
      modelName = show $ typeOf (undefined :: m)


data Field (name :: Symbol) typ = Field

class Typeable m => Model m where
  type TableName m :: Symbol

fieldName :: SingI name => (model -> Field name typ) -> String
fieldName (_ :: model -> Field name typ)
  = fromSing (sing :: Sing name)


tableName
  :: (Model model, SingI (TableName model))
  => (model -> Field name typ) -> String
tableName (_ :: model -> Field name typ)
  = fromSing (sing :: Sing (TableName model))


ident :: Field "id" (Ident model)
ident =  Field
