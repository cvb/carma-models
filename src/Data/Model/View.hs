
{-# LANGUAGE ScopedTypeVariables #-}

module Data.Model.View where

import Data.Text (Text)
import qualified Data.Text as T
import Data.Map (Map)
import qualified Data.Map as Map
import Data.Aeson as Aeson

import Data.Model
import Data.Model.Sql


data FieldView m = FieldView
  { name      :: Text
  , fieldType :: Text
  , meta      :: Map Text Aeson.Value
  , canWrite  :: Bool
  }

instance ToJSON (FieldView m) where
  toJSON f = object
    [ "name"     .= name f
    , "type"     .= fieldType f
    , "canWrite" .= canWrite f
    , "meta"     .= meta f
    ]

data View m = View
  { modelName :: Text
  , title     :: Text
  , fields    :: [FieldView m]
  }


instance ToJSON (View m) where
  toJSON v = object
    [ "name"      .= modelName v
    , "title"     .= title v
    , "fields"    .= fields v
    , "canCreate" .= True
    , "canRead"   .= True
    , "canUpdate" .= True
    , "canDelete" .= True
    ]


defaultView :: (Model m, ModelFields m ctr) => ctr -> View m
defaultView ctr
  = setDefaultModelName
  $ View
    { modelName = ""
    , title = ""
    , fields = map defaultFieldView $ modelFields ctr
    }
  where
    setDefaultModelName (v :: View m)
      = v { modelName = T.pack $ tableName (undefined :: m) }


defaultFieldView :: FieldDesc m -> FieldView m
defaultFieldView f = FieldView
  { name      = fd_fieldName f
  , fieldType = translateFieldType $ fd_fieldType f
  , meta      = Map.singleton "label" $ fd_fieldDesc f
  , canWrite  = True
  }


translateFieldType tr = case show tr of
  "Int" -> "int"
  t     -> error $ "translateFieldType: unkonwn type " ++ r
