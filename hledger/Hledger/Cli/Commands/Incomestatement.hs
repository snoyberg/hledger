{-# LANGUAGE QuasiQuotes, TemplateHaskell, OverloadedStrings, NoCPP #-}
{-|

The @incomestatement@ command prints a simple income statement (profit & loss report).

-}

module Hledger.Cli.Commands.Incomestatement (
  incomestatementmode
 ,incomestatement
 ,tests_Hledger_Cli_Commands_Incomestatement
) where

import Data.String.Here
import System.Console.CmdArgs.Explicit
import Test.HUnit

import Hledger
import Hledger.Cli.CliOptions
import Hledger.Cli.CompoundBalanceCommand

incomestatementSpec = CompoundBalanceCommandSpec {
  cbcname     = "incomestatement",
  cbcaliases  = ["is"],
  cbchelp     = [here|
This command displays a simple income statement, showing revenues
and expenses during a period. It assumes that these accounts are under a 
top-level `revenue` or `income` or `expense` account (case insensitive,
plural forms also allowed).

Note this report shows all account balances with normal positive sign
(like conventional financial statements, unlike balance/print/register)
(experimental).
  |],
  cbctitle    = "Income Statement",
  cbcqueries  = [
     CBCSubreportSpec{
      cbcsubreporttitle="Revenues"
     ,cbcsubreportquery=journalIncomeAccountQuery
     ,cbcsubreportnormalsign=NormallyNegative
     ,cbcsubreportincreasestotal=True
     }
    ,CBCSubreportSpec{
      cbcsubreporttitle="Expenses"
     ,cbcsubreportquery=journalExpenseAccountQuery
     ,cbcsubreportnormalsign=NormallyPositive
     ,cbcsubreportincreasestotal=False
     }
    ],
  cbctype     = PeriodChange
}

incomestatementmode :: Mode RawOpts
incomestatementmode = compoundBalanceCommandMode incomestatementSpec

incomestatement :: CliOpts -> Journal -> IO ()
incomestatement = compoundBalanceCommand incomestatementSpec

tests_Hledger_Cli_Commands_Incomestatement :: Test
tests_Hledger_Cli_Commands_Incomestatement = TestList
 [
 ]
