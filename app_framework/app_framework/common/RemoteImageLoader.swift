//
//  RemoteImageLoader.swift
//  TmdbTCA-UIKit
//
//  Created by JAVARENT on 09/08/26.
//

import UIKit

@MainActor
public final class RemoteImageLoader {
    static let shared = RemoteImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String) async -> UIImage? {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return nil }
        
        let key = urlString as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: key)
            
            return image
        } catch {
            return nil
        }
    }
}

public extension UIImageView {
    private static var lastURLKey: UInt8 = 0
    private static var loadTokenKey: UInt8 = 0
    
    private var lastRequestedURL: String? {
        get { objc_getAssociatedObject(self, &Self.lastURLKey) as? String }
        set { objc_setAssociatedObject(self, &Self.lastURLKey, newValue, .OBJC_ASSOCIATION_RETAIN)}
    }
    
    private var loadToken: UUID? {
        get { objc_getAssociatedObject(self, &Self.loadTokenKey) as? UUID }
        set { objc_setAssociatedObject(self, &Self.loadTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    func setRemoteImage(_ urlString: String) {
        guard urlString != lastRequestedURL else { return }
        lastRequestedURL = urlString
        image = nil
        
        let token = UUID()
        loadToken = token
        
        Task { [weak self] in
            guard let self else { return }
            let image = await RemoteImageLoader.shared.loadImage(from: urlString)
            guard self.loadToken == token else { return }
            self.image = image
        }
    }
}
