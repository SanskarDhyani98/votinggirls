import RBTree "mo:base/RBTree";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Char "mo:base/Char";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";

actor {
  let psk : Text = "theorywillonlytakeyousofar";

  var votedList = Buffer.Buffer<Text>(120);

  var votes : RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);

  func textToNat(t : Text) : Nat {
    var n : Nat = 0;
    for (c in t.chars()) {
      if (Char.isDigit(c)) {
        let charAsNat : Nat = Nat32.toNat(Char.toNat32(c) - 48);
        n := n * 10 + charAsNat;
      }
    };
    return n;
  };

  func personExistsVoters(e : Text) : Bool {
    for(p in votedList.vals()) {
      if (p == e) return true;
    };
    return false;
  };

  public query func getVotes() : async [(Text, Nat)] {
    Iter.toArray(votes.entries());
  };

  public func vote(voterMail : Text, entry : Text) : async [(Text, Nat)] {
    if (not personExistsVoters(voterMail)) {
    let votes_for_entry : ?Nat = votes.get(entry);

    let current_votes_for_entry : Nat = switch votes_for_entry {
      case null 0;
      case (?Nat) Nat;
    };

    votes.put(entry, current_votes_for_entry + 1);

    votedList.add(voterMail);

    Iter.toArray(votes.entries());
    } else return Iter.toArray(votes.entries());
  };

  public func resetVotes(passkey : Text) : async () {
    if (passkey == psk){
       votes := RBTree.RBTree(Text.compare);
       votedList.clear()
    };
  };

};