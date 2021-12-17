{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_Cantarelli_Final_PD (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.0.1\\Cantarelli-Final-PD-0.1.0.0-inplace"
dynlibdir  = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.0.1"
datadir    = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-9.0.1\\Cantarelli-Final-PD-0.1.0.0"
libexecdir = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\Cantarelli-Final-PD-0.1.0.0-inplace\\x86_64-windows-ghc-9.0.1\\Cantarelli-Final-PD-0.1.0.0"
sysconfdir = "C:\\Users\\Sofia\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Cantarelli_Final_PD_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Cantarelli_Final_PD_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Cantarelli_Final_PD_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Cantarelli_Final_PD_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Cantarelli_Final_PD_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Cantarelli_Final_PD_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
