module Status where

import Sound.Tidal.Context
import qualified Sound.Tidal.Tempo as T
import Control.Concurrent.MVar
import qualified Sound.OSC.FD as O
import Sound.Tidal.Config
import Text.Printf

{-getNow = do tempo <- readMVar $ sTempoMV tidal
            now <- O.time
            return $ floor $ timeToCycles tempo now -}

main = do putStrLn "Press enter to quit."
          (tempoMV, _) <- T.clocked (defaultConfig {cFrameTimespan = 1/10}) $ onTick
          getLine
          return ()
  where
    onTick mt state = do putStr $ (printf "%5d" $ toInt cyc)
                         putStr " "
                         putStr (map b2c $ __binary 8 (toInt $ fromRational cyc * 4))
                         putStr "\r"
                         return ()
                           where cyc = start $ T.nowArc state
                                 b2c True = 'x'
                                 b2c False = '_'
    toFloat :: Rational -> Float
    toFloat = fromRational
    toInt :: Rational -> Int
    toInt = floor . fromRational
