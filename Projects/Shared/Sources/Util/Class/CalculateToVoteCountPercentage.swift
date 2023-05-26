import Foundation

public enum CalculateToVoteCountPercentage {
    public static func calculateToVoteCountPercentage(firstVotingCount: Double, secondVotingCount: Double) -> (String, String, Int, Int) {
        let sum = Double(firstVotingCount) + Double(secondVotingCount)
        print("fasdf = \(firstVotingCount / sum)")
        let firstP = firstVotingCount / sum * 100.0
        let secondP = secondVotingCount / sum * 100.0
        
//        firstP = firstP.isNaN ? 0 : firstP
//        secondP = secondP.isNaN ? 0 : secondP
        
        let firstStr = String(firstP)
        let secondStr = String(secondP)
        
        return (firstStr, secondStr, Int(firstVotingCount), Int(secondVotingCount))
    }
}
