{-# LANGUAGE ForeignFunctionInterface #-}

module GhcSlave where

import Network.Socket
import Foreign.C.String
import System.IO
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Exception
import Control.Monad (when, forever)

import Remote.Slave

foreign export ccall startGhcSlave :: Bool -> Int -> CString -> IO ()

-- | @startGhcSlave@ is the exported slave function, that the
-- hosting application on the target needs to invoce to
-- start the slave process, and runs iserv.
startGhcSlave :: Bool -> Int -> CString -> IO ()
startGhcSlave verbose port s = do
  putStr "DocRoot: "
  base_path <- peekCString s
  putStrLn base_path
  -- _ <- forkIO $ startGhcSlave' verbose base_path (toEnum port)
  startSlave' verbose base_path (toEnum port)
  return ()
